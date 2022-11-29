import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/select_drill_request/select_drill_request.dart';
import 'package:spaid/model/request/select_drill_request/share_drill_request.dart';
import 'package:spaid/model/response/select_drill_response/select_drill_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';

class SelectDrillProvider extends BaseProvider {

  //region Private Members

  bool _isagree = false;
  List<Teams>? _teams;
  int? _totEvents;
  bool? _autoValidate;
  GetAllDrillPlanRequest? _getAllDrillPlanRequest;
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
  getSelectUserAsync(BuildContext context) async {
    try {
      this.context=context;


      await ApiManager()
          .getDio()!
          .post(Endpoints.getAllDrillPlanUrl, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}"))
          .then((response) => registerResponse(response,context))
          .catchError((onError) {
        ProgressBar.instance.stopProgressBar(context);

        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);

      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  /*
Return Type:
Input Parameters:
Use: registerResponse.
 */
  void registerResponse(Response response, BuildContext context) {
    if (response.data.length > 0) {
      GetAllDrillPlanResponse _response = GetAllDrillPlanResponse.fromJson(response.data);
      listener.onSuccess(_response, reqId: ResponseIds.GET_DRILL_PLAN_SCREEN);
    }else{
      ProgressBar.instance.stopProgressBar(context);
    }
  }
  /*
Return Type:
Input Parameters:getUserDetailsUrl used
Use: getSelectTeamAsync inputs and make profile  server call.
 */
  getSelectTeamAsync(BuildContext context) async {
    try {
      this.context=context;
      _getAllDrillPlanRequest = GetAllDrillPlanRequest();
      /*_selectTeamRequest.userIdNo = int.parse(
          "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}" ==
                  null
              ? "0"
              : "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");*/
      // print("UserID"+ "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      _getAllDrillPlanRequest!.iDNo = int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
      //print(_selectTeamRequest.userIdNo.toString());
      // _selectTeamRequest.userIdNo = 1;

      await ApiManager()
          .getDio()!
          .post(Endpoints.getSharedDrillPlan, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"))
          .then((response) => registerResponse(response,context))
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

  shareDrill(BuildContext ctxt, String drillName, GetAllDrillPlanResponse newSelectDrillResponse) async{

    try {
      ShareDrillRequest _shareDrillRequest=ShareDrillRequest();
      _shareDrillRequest.userIDNo=await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
      _shareDrillRequest.sharedDrillPlan=drillName;
      List<DrillPlanList> drillPlanList=[];
      for(int i=0;i<newSelectDrillResponse.result!.allDrillPlanList!.length;i++){
        if(newSelectDrillResponse.result!.allDrillPlanList![i].isSelected!){
          DrillPlanList _drillPlanList=DrillPlanList();
          _drillPlanList.description=drillName;
          _drillPlanList.drillId=newSelectDrillResponse.result!.allDrillPlanList![i].teamDrillPlanId.toString();
          // _drillPlanList.drillImage=newSelectDrillResponse.allDrillPlanList[i].teamDrillPlanId.toString();
          drillPlanList.add(_drillPlanList);
          newSelectDrillResponse.result!.allDrillPlanList![i].isSelected=false;
        }

      }
      _shareDrillRequest.drillPlanList=drillPlanList;
      setRefreshScreen();
      Navigation.navigateWithArgument(
          context!,
          MyRoutes
              .shareDrillScreen,_shareDrillRequest);

      // Navigator.of(ctxt).pop();

    } catch (e) {
print(e);
    }
  }

  void setRefreshScreen(){
    listener.onRefresh("");

  }
}




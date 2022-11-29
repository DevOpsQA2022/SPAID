import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/create_new_drill_request.dart';
import 'package:spaid/model/request/getDrill_plan_request/getDrill_plan_request.dart';
import 'package:spaid/model/request/update_drill_plan_request/update_drill_plan_request.dart';
import 'package:spaid/model/response/create_new_drill_response.dart';
import 'package:spaid/model/response/getDrill_Plan_response/getDrill_plan_response.dart';
import 'package:spaid/model/response/get_drill_response.dart';
import 'package:spaid/model/response/update_drill_plan_response/update_drill_plan_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/ui/SelectDrill_Screen/select_drill_screen_provider.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/progressBar.dart';

import '../../model/request/get_drill_request.dart';
import 'package:intl/intl.dart';

class HomeScreenProvider extends BaseProvider {


   GetDrillCategoryRequest? getDrillCategoryRequest;
   GetDrillCategoryResponse? getDrillCategoryResponse;
   GetDrillPlanResponse? getDrillPlanResponse;

   TextEditingController? categoryDescriptionController;
   TextEditingController? planDescriptionController;
   TextEditingController? planImageController;
   TextEditingController? planNotesController;
   String durationController = '';
   int? duration;
   BuildContext? context;


   DateTime dateTime = DateTime.now();

   // TextEditingController? durationController;
   // DateTime dateTime = DateTime.now();
   String formattedDate = DateFormat('dd/yyyy/MM').format(DateTime.now());
   CreateNewDrillPlanRequest? _createNewDrillPlanRequest;
   UpdateDrillPlanRequest? _UpdateDrillPlanRequest;

   bool? _autoValidate;
  initialProvider(BuildContext context) async {
    // print(formattedDate);
    categoryDescriptionController = TextEditingController();
    planDescriptionController = TextEditingController();
    planImageController = TextEditingController();
    planNotesController = TextEditingController();
    durationController = '';
    dateTime = DateTime.now();
    this.context=context;

    // durationController = TextEditingController();
    planDescriptionController = TextEditingController();
    _autoValidate = false;
    // getDrillPlanResponse!.teamDrillPlanId = int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamDrillPlanId)}");


  }

  void setRefreshScreen() {
    listener.onRefresh("");
  }


   /*
Return Type:
Input Parameters:Bool
Use: Initiate value to the variable and create object.
 */
   void setAutoValidate(bool value) {
     //_autoValidate = value;
     _autoValidate = true;
     notifyListeners();
   }

   bool? get getAutoValidate => _autoValidate;
   /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
   createDrillAsync(Uint8List drillImage) async {
     try {
       _createNewDrillPlanRequest = CreateNewDrillPlanRequest();
       _createNewDrillPlanRequest!.userIdNo =int.parse((await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)));
       _createNewDrillPlanRequest!.teamIdNo = int.parse((await SharedPrefManager.instance.getStringAsync(Constants.teamID)));
       _createNewDrillPlanRequest!.planDescription = planDescriptionController!.text;
       _createNewDrillPlanRequest!.categoryDescription = categoryDescriptionController!.text;
       _createNewDrillPlanRequest!.drillDate = DateFormat('dd/MM/yyyy').format(dateTime);
       _createNewDrillPlanRequest!.duration = duration!;
       _createNewDrillPlanRequest!.planImage = jsonEncode(Constant.paintHistory.map((e) => e.toJson()).toList());
       _createNewDrillPlanRequest!.planNotes = planNotesController!.text;
       _createNewDrillPlanRequest!.planPngImage =drillImage ;
       _createNewDrillPlanRequest!.planVideoLink = "www.youtube.com";


       // _createTeamRequest.UserIDNo = "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}";
       // _createTeamRequest.RoleIdNo =  -10001 ;
       // // _createTeamRequest.RoleIdNo = "${await SharedPrefManager.instance.getStringAsync(Constants.roleId)}" ==  MyStrings.managerRole ? -10002 : "${ await SharedPrefManager.instance.getStringAsync(Constants.roleId)}" == MyStrings.playerRole  ? "-10003" : "-10005";
       // _createTeamRequest.teamTimeZone = timezoneController.text;
       // _createTeamRequest.sportIdNo = "10001";


       await ApiManager()
           .getDio()!
           .post(Endpoints.createNewDrillPlanUrl, data: _createNewDrillPlanRequest)
           .then((response) => createDrillPlanResponse(response))
           .catchError((onError) {
         listener.onFailure(DioErrorUtil.handleErrors(onError));
       });
     } catch (e) {
       print(e);
       listener.onFailure(ExceptionErrorUtil.handleErrors(e));
     }
   }

   /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
   updateDrillAsync(BuildContext context, Uint8List drillImage, SelectDrillProvider selectDrillProvider) async {
     try {
       _UpdateDrillPlanRequest = UpdateDrillPlanRequest();
       _UpdateDrillPlanRequest!.userIdNo = int.parse((await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)));
       _UpdateDrillPlanRequest!.teamIdNo = int.parse((await SharedPrefManager.instance.getStringAsync(Constants.teamID)));
       _UpdateDrillPlanRequest!.planDescription = planDescriptionController!.text;
       _UpdateDrillPlanRequest!.categoryDescription = categoryDescriptionController!.text;
       _UpdateDrillPlanRequest!.drillDate = DateFormat('dd/MM/yyyy').format(dateTime);
       _UpdateDrillPlanRequest!.duration = duration!;
       _UpdateDrillPlanRequest!.planImage = jsonEncode(Constant.paintHistory.map((e) => e.toJson()).toList());
       _UpdateDrillPlanRequest!.planNotes = planNotesController!.text;
       _UpdateDrillPlanRequest!.planPngImage = drillImage;
       _UpdateDrillPlanRequest!.planVideoLink = "www.youtube.com";
       _UpdateDrillPlanRequest!.teamDrillPlanId = int.parse((await SharedPrefManager.instance.getStringAsync(Constants.teamDrillPlanId)));
       _UpdateDrillPlanRequest!.teamDrillCategoryId = int.parse((await SharedPrefManager.instance.getStringAsync(Constants.teamDrillCategoryId)));





       await ApiManager()
           .getDio()!
           .post(Endpoints.updateDrillPlan, data: _UpdateDrillPlanRequest)
           .then((response) => updateDrillPlanResponse(response,context,selectDrillProvider))
           .catchError((onError) {
         Navigation.finishAndNavigateWithArgument(context, MyRoutes.homeScreen, 4);
         listener.onFailure(DioErrorUtil.handleErrors(onError));
       });
     } catch (e) {
       print(e);
       Navigation.finishAndNavigateWithArgument(context, MyRoutes.homeScreen, 4);
       listener.onFailure(ExceptionErrorUtil.handleErrors(e));
     }
   }

  getDrill() async {

    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.getDrillUrl, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}"))
          .then((response) => getDrillResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      print(e);
    }
  }

   getAllDrill() async {

     try {
       await ApiManager()
           .getDio()!
           .post(Endpoints.getAllDrillUrl, data: int.parse("${await SharedPrefManager.instance.getStringAsync(Constants.teamDrillPlanId)}"))
           .then((response) => getAllDrillResponse(response))
           .catchError((onError) {
         listener.onFailure(DioErrorUtil.handleErrors(onError));
       });
     } catch (e) {
       print(e);
     }
   }

  void getDrillResponse(Response response) {
    GetDrillCategoryResponse GetDrillResponse = GetDrillCategoryResponse
        .fromJson(response.data);
    getDrillCategoryResponse = GetDrillResponse;
    listener.onSuccess(
        GetDrillResponse, reqId: ResponseIds.GET_DRILL_CATEGORY_SCREEN);
  }

   void getAllDrillResponse(Response response) {
     GetDrillPlanResponse _GetDrillPlanResponse = GetDrillPlanResponse
         .fromJson(response.data);
     getDrillPlanResponse = _GetDrillPlanResponse;
     listener.onSuccess(
         _GetDrillPlanResponse, reqId: ResponseIds.GET_DRILL_SCREEN);
   }

   void createDrillPlanResponse(Response response) {
     ProgressBar.instance.stopProgressBar(context!);

     if (response.data.length > 0) {
       CreateNewDrillPlanResponse _response = CreateNewDrillPlanResponse.fromJson(response.data);
       listener.onSuccess(_response, reqId: ResponseIds.CREATE_CATEGORY_SCREEN);
     }else{
     }

   }

   void updateDrillPlanResponse(Response response, BuildContext context, SelectDrillProvider selectDrillProvider) {
     ProgressBar.instance.stopProgressBar(this.context!);

     Navigation.finishAndNavigateWithArgument(context, MyRoutes.homeScreen, 4);
     if (response.data.length > 0) {
       UpdateDrillPlanResponse _response = UpdateDrillPlanResponse.fromJson(response.data);
       listener.onSuccess(_response, reqId: ResponseIds.UPDATE_DRILL_SCREEN);
     }else{
     }


   }

   clearProvider() {
     planNotesController!.clear();
     planImageController!.clear();
     planDescriptionController!.clear();

   }
}




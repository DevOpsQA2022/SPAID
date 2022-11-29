import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/request/notification_request/notification_request.dart';
import 'package:spaid/model/request/roaster_listview_request/team_members_details_request.dart';
import 'package:spaid/model/request/select_team_request/select_team_request.dart';
import 'package:spaid/model/response/notification_response/notification_response.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/utils/shared_pref_manager.dart';

class NotificationProvider extends BaseProvider {
//region Private Members
  SelectTeamRequest? _selectTeamRequest;
  BuildContext? context;
//endregion

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  init(BuildContext context) async {
    this.context=context;

  }



  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  getNotificationAsync() async {
    try {

      await ApiManager()
              .getDio()!
              .post(Endpoints.serverNotificationUrl+Endpoints.notificationUrl, data: int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}"))
              .then((response) => registerResponse(response))
              .catchError((onError) {
            listener.onFailure(DioErrorUtil.handleErrors(onError));
          });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void registerResponse(Response response) {
    NotificationResponse _response =
        NotificationResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.NOTIFICATION_SCREEN);
  }

  /*
Return Type:
Input Parameters:
Use: Create API Calls and Handle Exceptions.
 */
  removeNotificationAsync(int notificationId,bool showMessage) async {
    try {


      await ApiManager()
          .getDio()!
          .post(Endpoints.serverNotificationUrl+Endpoints.removeNotification, data: notificationId)
          .then((response) => removeNofication(response,showMessage))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void removeNofication(Response response, bool showMessage) {
    if(showMessage) {
      final snackBar = SnackBar(content: Text('Notification deleted'));
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
    getNotificationAsync();
  }


  updateCalendarAsync(bool addToCalendar) async {
    try {
      GetTeamMemberDetailsRequest _getTeamMemberDetailsRequest = GetTeamMemberDetailsRequest();
      _getTeamMemberDetailsRequest.userIDNo =int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}") ;
      _getTeamMemberDetailsRequest.UserRoleId =addToCalendar?1:0 ;
      _getTeamMemberDetailsRequest.teamIDNo =int.parse( "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");

      await ApiManager()
          .getDio()!
          .post(Endpoints.updateUserCalendar, data: _getTeamMemberDetailsRequest)
          .then((response) => print(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });

    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }
}

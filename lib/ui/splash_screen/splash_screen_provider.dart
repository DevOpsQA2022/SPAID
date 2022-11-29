import 'package:dio/dio.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/model/response/game_event_response/player_availability_request.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/model/update_volunteer_availablity.dart';
import 'package:spaid/service/api_manager.dart';
import 'package:spaid/service/dio_error_util.dart';
import 'package:spaid/service/endpoints.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/response_ids.dart';

class SplashScreenProvider extends BaseProvider{

  void initialiseAsync() async{
    await  Future.delayed(Duration(seconds: Constants.SplashScreenSeconds),_navigation );
  }

  _navigation(){
    listener.onSuccess(true,reqId: ResponseIds.SPLASH_SCREEN);
  }

  void updatePlayerAvalAsync(String status, String refer, String userid,String note) async{
    print("Marlen Franto"+note);
    UpdatePlayerAvailability _updatePlayerRequest = UpdatePlayerAvailability();
    _updatePlayerRequest.referenceTableId=int.parse(refer);
    _updatePlayerRequest.userId=int.parse(userid);
    _updatePlayerRequest.availabilityStatusId=int.parse(status);
    _updatePlayerRequest.notificationTypeId=5;
    _updatePlayerRequest.notes=note;
    _updatePlayerRequest.isDeleted=1;



    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.updatePlayerAvailability, data: _updatePlayerRequest)
          .then((response) => playermailResponse(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

  void playermailResponse(Response response) {
    ValidateUserResponse _response = ValidateUserResponse.fromJson(response.data);
    listener.onSuccess(_response, reqId: ResponseIds.PLAYER_MAIL_RESPONSE);
  }


  void updateVolunteerAvalAsync(String eventVolunteerTypeId, String volunteerTypeId, String volunteer, String refer, String userid, String status, ) async{
    UpdateVolunteerAvailability _updatePlayerRequest = UpdateVolunteerAvailability();
    _updatePlayerRequest.eventId=refer;
    _updatePlayerRequest.userId=userid;
    _updatePlayerRequest.availabilityStatusId=status;
    _updatePlayerRequest.volunteerTypeId=volunteerTypeId;
    _updatePlayerRequest.eventVoluenteerTypeIDNo=eventVolunteerTypeId;
    _updatePlayerRequest.volunteerTypeName=volunteer;



    try {
      await ApiManager()
          .getDio()!
          .post(Endpoints.serverGameUrl+Endpoints.updateVolunteerStatus, data: _updatePlayerRequest)
          .then((response) => print(response))
          .catchError((onError) {
        listener.onFailure(DioErrorUtil.handleErrors(onError));
      });
    } catch (e) {
      listener.onFailure(ExceptionErrorUtil.handleErrors(e));
    }
  }

}
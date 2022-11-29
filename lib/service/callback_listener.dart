
import 'package:spaid/model/response/base_response.dart';

abstract class OnCallBackListener{

  void onSuccess(dynamic any , {required int reqId});

  void onFailure(BaseResponse baseResponse);

  void onRefresh(String type);
}
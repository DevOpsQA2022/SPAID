import 'package:flutter/material.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/service/callback_listener.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    implements OnCallBackListener {
  @override
  void onSuccess(any, {required int reqId}) {
    // TODO: implement onSuccess
  }

  @override
  void onFailure(BaseResponse error) {}

  @override
  void onRefresh(String type){
setState(() {

});
  }
}

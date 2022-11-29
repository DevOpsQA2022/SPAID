import 'package:flutter/material.dart';
import 'package:spaid/base/base_model.dart';
import 'package:spaid/service/callback_listener.dart';


abstract class BaseProvider<T extends BaseModal> with ChangeNotifier{

  late OnCallBackListener listener;


}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spaid/support/colors.dart';

class Toasting {
  static showAlertMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: Colors.red[400], textColor: Colors.white);
  }

  static showWarningMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: MyColors.errorColor,
        textColor: Colors.white);
  }

  static showMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        textColor: MyColors.white,
        backgroundColor: MyColors.kPrimaryColor);
  }
}

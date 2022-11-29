import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:spaid/support/colors.dart';


class  CodeSnippet {
  static final CodeSnippet _singleton = new CodeSnippet._internal();

  CodeSnippet._internal();

  static CodeSnippet get instance => _singleton;

  void enableStatusBar(bool isEnable) {
    if (isEnable)
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    else
      SystemChrome.setEnabledSystemUIOverlays([]);
  }


  String getFormattedDate(
      String date, String inputFormat, String outputFormat) {
    DateFormat dateFormat = DateFormat(inputFormat);
    DateFormat dateFormatOutput = DateFormat(outputFormat);
    DateTime dateTime = dateFormat.parse(date);
    return dateFormatOutput.format(dateTime);
  }

  String? setData(String data) {
    if (data != null) return toBeginningOfSentenceCase(data);
    return "";
  }


  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      showAlertMsg('no internet');
      return false;
    } on SocketException catch (_) {
      showAlertMsg('no internet');
      return false;
    }
  }

  showAlertMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: Colors.red[400], textColor: Colors.white);
  }

  showWarningMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: MyColors.errorColor, textColor: Colors.white);
  }

  showMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      );
  }

  dayBetween(int startDate, int endDate) {
    int oneDay = 1000 * 60 * 60 * 24;
    int diff = (startDate - endDate).abs();
    int day = (diff / oneDay).round();
    print(day);
  }

// logout(BuildContext context) {
//   SharedPrefManager.instance.clearAll();
//   Navigator.pushReplacementNamed(context, Routes.login);
// }


}

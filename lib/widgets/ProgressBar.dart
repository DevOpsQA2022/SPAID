import 'package:flutter/material.dart';
import 'package:spaid/widgets/custom_loader.dart';

class ProgressBar {
  BuildContext? _context;
  static final ProgressBar _progressbar = ProgressBar._internal();

  factory ProgressBar() {
    return _progressbar;
  }

  ProgressBar._internal();

  static ProgressBar get instance => _progressbar;
  bool _isShowing=false;

  void setContext(BuildContext context) {
    _context = context;
  }

  void showProgressbar(BuildContext context) {
    _context = context;
    _isShowing = true;
    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child:   CustomLoader());
      },
    );
  }

  void stopProgressBar(BuildContext context) {
    if (_isShowing) {
      Navigator.pop(context);
      _isShowing = false;
    }
  }
}

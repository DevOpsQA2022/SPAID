import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';


const _inactivityTimeout = Duration(seconds: 10);
Timer? _keepAliveTimer;

void _keepAlive(bool visible) {
  _keepAliveTimer?.cancel();
  if (visible) {
    _keepAliveTimer = null;
  } else {
    _keepAliveTimer = Timer(_inactivityTimeout, () => exit(0));
  }
}

class _KeepAliveObserver extends WidgetsBindingObserver {
  @override didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        _keepAlive(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _keepAlive(false);  // Conservatively set a timer on all three
        break;
    }
  }
}

void startKeepAlive() {
  assert(_keepAliveTimer == null);
  _keepAlive(true);
  WidgetsBinding.instance.addObserver(_KeepAliveObserver());
}